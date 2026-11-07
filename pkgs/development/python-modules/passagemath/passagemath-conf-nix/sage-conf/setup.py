from setuptools import setup
from setuptools.dist import Distribution

# setuptools plugins considered harmful:
# If build isolation is not in use and setuptools_scm is installed,
# then its file_finders entry point is invoked, which we don't need.
# And with setuptools_scm 8, we get more trouble:
# LookupError: pyproject.toml does not contain a tool.setuptools_scm section
# LookupError: setuptools-scm was unable to detect version ...
# We just remove all handling of "setuptools.finalize_distribution_options" entry points.
Distribution._removed = staticmethod(lambda ep: True)

setup()
