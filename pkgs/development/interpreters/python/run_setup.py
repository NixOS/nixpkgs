# -*- coding: utf-8 -*-

import setuptools
import tokenize

__file__='setup.py';

exec(compile(getattr(tokenize, 'open', open)(__file__).read().replace('\\r\\n', '\\n'), __file__, 'exec'))
