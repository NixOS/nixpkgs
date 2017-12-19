#!/usr/bin/env python

import camxes, json, sys

def clean(s):
    return s.replace("\n", " ")

print json.dumps(camxes.parse(clean(sys.stdin.read())).primitive)
