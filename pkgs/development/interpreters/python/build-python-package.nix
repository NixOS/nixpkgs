/* This function provides a generic Python package builder.  It is
   intended to work with packages that use `distutils/setuptools'
   (http://pypi.python.org/pypi/setuptools/), which represents a large
   number of Python packages nowadays.  */

{ lib
, python
, mkPythonDerivation
, bootstrapped-pip
, flit
}:

let
  setuptools-specific = import ./build-python-package-setuptools.nix { inherit lib python bootstrapped-pip; };
  flit-specific = import ./build-python-package-flit.nix { inherit python flit; };
  wheel-specific = import ./build-python-package-wheel.nix { };
  common = import ./build-python-package-common.nix { inherit python bootstrapped-pip; };
in

{
# Several package formats are supported.
# "setuptools" : Install a common setuptools/distutils based package. This builds a wheel.
# "wheel" : Install from a pre-compiled wheel.
# "flit" : Install a flit package. This builds a wheel.
# "other" : Provide your own buildPhase and installPhase.
format ? "setuptools"
, ... } @ attrs:

let
  formatspecific =
    if format == "setuptools" then common (setuptools-specific attrs)
    else if format == "flit" then common (flit-specific attrs)
    else if format == "wheel" then common (wheel-specific attrs)
    else if format == "other" then {}
    else throw "Unsupported format ${format}";

in mkPythonDerivation ( attrs // formatspecific )
