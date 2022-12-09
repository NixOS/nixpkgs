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
  version = "0.10.0";
  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "meson_python";
    hash = "sha256-CN0SLBB029XFW1OZOnGcynPdghY3LJEhf3pVAmD55+E=";
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
