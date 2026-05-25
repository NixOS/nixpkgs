import sys
import re
import json
import base64
import argparse
import requests
from urllib.parse import urlparse

def process_github_release(url, token=None):
    parsed = urlparse(url)
    path_parts = parsed.path.strip('/').split('/')
    if len(path_parts) < 5 or parsed.netloc != 'github.com':
        raise ValueError("Invalid GitHub release URL format")
    owner, repo, _, _, tag = path_parts[:5]
    headers = {"Accept": "application/vnd.github.v3+json"}
    if token:
        headers["Authorization"] = f"Bearer {token}"
    response = requests.get(
        f"https://api.github.com/repos/{owner}/{repo}/releases/tags/{tag}",
        headers=headers
    )
    if response.status_code != 200:
        raise RuntimeError(f"Failed to fetch release info: {response.status_code} ({response.json().get('message')})")
    release_data = response.json()
    assets = release_data.get('assets', [])
    result = {}
    sha256_pattern = re.compile(r"^[a-fA-F0-9]{64}$")
    for asset in assets:
        if not asset['name'].endswith('.sha256'):
            continue
        download_url = asset['browser_download_url']
        content_response = requests.get(download_url, headers=headers)
        if content_response.status_code != 200:
            raise RuntimeError(
                f"Failed to download {asset['name']}: "
                f"{content_response.status_code} {content_response.text}"
            )
        hex_hash = content_response.text.strip()
        if not sha256_pattern.match(hex_hash):
            raise ValueError(f"Invalid SHA256 format in {asset['name']}")
        try:
            byte_data = bytes.fromhex(hex_hash)
            base64_hash = base64.b64encode(byte_data).decode('utf-8')
        except Exception as e:
            raise RuntimeError(f"Error processing {asset['name']}: {str(e)}")
        filename = asset['name'][:-7]
        result[filename] = f"sha256-{base64_hash}"
    output_file = f"{repo}_{tag}_hashes.json"
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(result, f, indent=2, ensure_ascii=False)
    print(f"Successfully generated {output_file}")
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Process GitHub release hashes')
    parser.add_argument('url', help='GitHub release URL')
    parser.add_argument('-t', '--token', help='GitHub API token (optional)')
    args = parser.parse_args()
    try:
        process_github_release(args.url, args.token)
    except Exception as e:
        print(f"Error: {str(e)}")
        sys.exit(1)
