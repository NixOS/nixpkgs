#!/usr/bin/env bash

git ls-remote https://github.com/lxde/$1 'refs/tags/*^{}'
