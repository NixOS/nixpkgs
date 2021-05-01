"""
This script is part of fetchPythonRequirements
It is meant to be used with mitmproxy via `--script`
It will filter api repsonses from the pypi.org api (used by pip),
to only contain files with release date < MAX_DATE

For retrieving the release dates for files, it uses the pypi.org json api
It has to do one extra api request for each queried package name
"""
import json
import os
import re
from urllib import request
import dateutil.parser

from mitmproxy import http


def get_files_to_hide(pname, max_ts):
    """
    Query the pypi json api to get timestamps for all release files of the given pname.
    return all file names which are newer than the given timestamp
    """
    url = f"https://pypi.org/pypi/{pname}/json"
    with request.urlopen(url) as f:
        resp = json.load(f)
    files = []
    for ver, releases in resp['releases'].items():
        for release in releases:
            ts = dateutil.parser.parse(release['upload_time']).timestamp()
            if ts > max_ts:
                files.append(release['filename'])
    return files


# accept unix timestamp or human readable format
try:
    max_ts = int(os.getenv("MAX_DATE"))
except ValueError:
    max_date = dateutil.parser.parse(os.getenv("MAX_DATE"))
    max_ts = max_date.timestamp()


def response(flow: http.HTTPFlow) -> None:
    if not "/simple/" in flow.request.url:
        return
    pname = flow.request.url.strip('/').split('/')[-1]
    badFiles = get_files_to_hide(pname, max_ts)
    html = flow.response.text
    for fname in badFiles:
        if fname not in html:
            continue
        pattern = rf'<a href="https://files.pythonhosted.org/packages/../../[\d\w]+/{fname}#sha256=[\d\w]+".*>{fname}</a>'
        html_new = re.sub(pattern, "", html)
        if html == html_new:
            raise Exception(
                f"Removing file {fname} from pypi response failed.\n"
                f"Check the regex in {__file__}"
                f"html document: \n{html}")
        html = html_new
    flow.response.text = html

