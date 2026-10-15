#!/usr/bin/env python3

import glob
import sys
path_glob = sys.argv[1]
do_print = sys.argv[2].strip() != ""
attribute_description = sys.argv[2] if len(sys.argv) > 2 else "Glob"
if not len(path_glob):
    sys.exit('Got an empty {}. Aborting'.format(attribute_description.lower()))
if do_print:
    path_expanded = glob.glob(path_glob)
    is_empty = not len(path_expanded)
else:
    is_empty = next(glob.iglob(path_glob), None) is None
if is_empty:
    sys.exit('{} "{}" does not match any paths. Aborting'.format(attribute_description, path_glob))
if do_print:
    for path in path_expanded:
        print(path)
