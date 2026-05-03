# Extension with Python 2 packages that is overlaid on top
# of the Python 3 packages set. This way, Python 2+3 compatible
# packages can still be used.

self: super:

with self;
with super;
{
  bootstrapped-pip = toPythonModule (callPackage ./python2-modules/bootstrapped-pip { });

  pip = callPackage ./python2-modules/pip { };

  setuptools = callPackage ./python2-modules/setuptools { };

  wheel = callPackage ./python2-modules/wheel { };
}
