{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, colorama
, meson
, ninja
, pyproject-metadata
, tomli
}:

buildPythonPackage rec {
  pname = "meson-python";
  version = "0.6.0";
  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "meson_python";
    hash = "sha256-/bX7s6ttdTav/+qPt9CYREb4t5vHCz+8mA5DvV81bfM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pyproject-metadata
    tomli
  ];

  propagatedBuildInputs = [
    colorama
    meson
    ninja
    pyproject-metadata
    tomli
  ];

  # Ugly work-around. Drop ninja dependency.
  # We already have ninja, but it comes without METADATA.
  # Building ninja-python-distributions is the way to go.
  postPatch = ''
    substituteInPlace pyproject.toml --replace "'ninja'," ""
  '';

  meta = {
    description = "Meson Python build backend (PEP 517)";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.fridh ];
  };
}