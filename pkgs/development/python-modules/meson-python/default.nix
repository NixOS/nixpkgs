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
  version = "0.12.0";
  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "meson_python";
    hash = "sha256-jLFZqAk6LnPPqJf4CS7JO3TjhC+U3/f944HG/g4LBk0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pyproject-metadata
    tomli
  ];

  propagatedBuildInputs = [
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
    homepage = "https://github.com/FFY00/meson-python";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.fridh ];
  };
}
