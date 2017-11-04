# A Python "namespace package" http://www.python.org/dev/peps/pep-0382/
# This always goes inside of a namespace package's __init__.py

from pkgutil import extend_path
__path__ = extend_path(__path__, __name__)