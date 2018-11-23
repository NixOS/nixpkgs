# -*- coding: utf-8 -*-

import setuptools
import tokenize

from distutils import sysconfig

__file__='setup.py';

sysconfig._config_vars = None
sysconfig.get_config_var("LDSHARED")
sysconfig._config_vars["SHLIB_SUFFIX"] = 

exec(compile(getattr(tokenize, 'open', open)(__file__).read().replace('\\r\\n', '\\n'), __file__, 'exec'))
# -*- coding: utf-8 -*-

import sys
import os
import setuptools
import tokenize

from distutils import sysconfig

__file__='setup.py';

_get_python_lib = sysconfig.get_python_lib
def get_python_lib(plat_specific=0, standard_lib=0, prefix=None):
    if 'PYTHONXCPREFIX' in os.environ:
        print("Setting prefix")
        prefix = os.environ['PYTHONXCPREFIX']

    return _get_python_lib(plat_specific, standard_lib, prefix)

sysconfig.get_python_lib = get_python_lib
sysconfig.PREFIX = sysconfig.EXEC_PREFIX = os.environ['PYTHONXCPREFIX']
sysconfig._config_vars = None
sysconfig.get_config_var("LDSHARED")

print("Include is ", sysconfig.get_config_var('CFLAGS'), sys.modules['sysconfig'])

print("Running setup cross")
exec(compile(getattr(tokenize, 'open', open)(__file__).read().replace('\\r\\n', '\\n'), __file__, 'exec'))
