"""Recursively load pth files in site-packages of sys.path

- Append paths from PYTHON<VERSION>PATH environment variable to sys.path
- iterate over sys.path
- check for pth in dirs that end in site-packages
- ignore import statements in pth files
- add dirs listed in pth files right after current sys.path element,
  they will be processed in next iteration
"""

import os
import site
import sys

# Append paths from PYTHON<VERSION>PATH environment variable to sys.path. Use
# of this (admittedly non-standard) variable enables a safer way to extend
# Python interpreters with modules that are installed in a nix profile.
#
# Instead of the unsafe
#   export PYTHONPATH=~/.nix-profile/lib/python2.7/site-packages
# which probably breaks if you start python3, you can now
#   export PYTHON27PATH=~/.nix-profile/lib/python2.7/site-packages
#   export PYTHON33PATH=~/.nix-profile/lib/python3.3/site-packages
# and there will be no interference between python2.7 and python3.3.
pythonpath = os.getenv("PYTHON%d%dPATH" % (sys.version_info.major, sys.version_info.minor))
if pythonpath:
    sys.path.extend(pythonpath.split(os.pathsep))

for path_idx, sitedir in enumerate(sys.path):
    # ignore non-site-packages
    if not sitedir.endswith('site-packages'):
        continue

    # find pth files
    try:
        names = os.listdir(sitedir)
    except os.error:
        continue
    dotpth = os.extsep + "pth"
    pths = [name for name in names if name.endswith(dotpth)]

    for pth in pths:
        fullname = os.path.join(sitedir, pth)
        try:
            f = open(fullname, "rU")
        except IOError:
            continue

        with f:
            for n, line in enumerate(f):
                if line.startswith("#"):
                    continue

                if line.startswith(("import ", "import\t")):
                    continue

                line = line.rstrip()
                dir, dircase = site.makepath(sitedir, line)
                if not dircase in sys.path:
                    sys.path.insert(path_idx+1, dir)
