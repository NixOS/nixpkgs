# TODO format with nixpkgs (comma position ?)
{ lib
, stdenv
, testers
, buildPythonPackage
, fetchFromGitHub
, python3
, ifcopenshell
# python deps
, python3Packages
# , setuptools
# , build
# , mathutils
# , shapely
# , numpy
# , isodate
# , python-dateutil
# , lark
# , wheel
}:
buildPythonPackage rec {
  pname = "ifcopenshell";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner  = "IfcOpenShell";
    repo   = "IfcOpenShell";
    rev = "refs/tags/ifcopenshell-python-0.7.9";
    fetchSubmodules = true;
    sha256 = "sha256-DtA8KeWipPfOnztKG/lrgLZeOCUG3nWR9oW7OST7koc=";
  };

  nativeBuildInputs = [ python3 ];
  propagatedBuildInputs = with python3Packages; [ wheel build setuptools ];
  # build-system = [
  #   setuptools
  # ];

  pythonImportsCheck = [ "ifcopenshell" ];

  buildInputs = [
    # ifcopenshell needs stdc++
    # stdenv.cc.cc.lib
    # boost179
    # cgal
    # gmp
    # icu
    # mpfr
    # pcre
    # libxml2
    # hdf5
    # opencascade-occt
    # libaec
    ifcopenshell
    python3
  ];

  # dependencies = [
  #   mathutils
  #   shapely
  #   numpy
  #   isodate
  #   python-dateutil
  #   lark
  # ];

  preConfigure = ''
    cd src/ifcopenshell-python
    # The build process is here: https://github.com/IfcOpenShell/IfcOpenShell/blob/v0.8.0/src/ifcopenshell-python/Makefile#L131
    # but we'd have to patch the copied pyproject.toml anyway, as the version is incorrect (even after their `make dist` btw), and the `where = ["dist"]` does not apply to us.
    cat << EOF > pyproject.toml
[build-system]
requires = ["setuptools>=61.0"]
build-backend = "setuptools.build_meta"
[project]
name = "ifcopenshell"
version = "0.7.9"
authors = [
  { name="Dion Moult", email="dion@thinkmoult.com" },
]
description = "Python bindings, utility functions, and high-level API for IfcOpenShell"
readme = "README.md"
requires-python = ">=3.6,<3.12"
classifiers = [
    "Programming Language :: Python :: 3",
    "License :: OSI Approved :: GNU Lesser General Public License v3 or later (LGPLv3+)",
]
[project.optional-dependencies]
geometry = ["mathutils", "shapely"]
date = ["isodate"]
[project.urls]
"Homepage" = "http://ifcopenshell.org"
"Bug Tracker" = "https://github.com/ifcopenshell/ifcopenshell/issues"
[tool.setuptools.packages.find]
include = ["ifcopenshell*"]
[tool.setuptools.package-data]
ifcopenshell = ["*.pyd", "*.so", "*.json"]
"ifcopenshell.util" = ["*.json", "schema/*.ifc"]
EOF
    # NOTE: the following is directly inspired by https://github.com/IfcOpenShell/IfcOpenShell/blob/v0.8.0/src/ifcopenshell-python/Makefile#L131
    # TODO find a better way to find it or suggest upstream improvement ;-)
    cp -v ${ifcopenshell.out}/lib/python3.11/site-packages/ifcopenshell/ifcopenshell_wrapper.py ./ifcopenshell/
    cp -v ${ifcopenshell.out}/lib/python3.11/site-packages/ifcopenshell/_ifcopenshell_wrapper.so ./ifcopenshell/
	# distutils cannot access anything outside the cwd, so hackishly swap out the README.md
	cp README.md ../README.bak
	cp ../../README.md README.md
	# sed "s/999999//" pyproject.toml
	# python -m build
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Open source IFC library and geometry engine, python bindings.";
    homepage = "http://ifcopenshell.org/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ fehnomenal ];
  };

  # passthru.tests.version = testers.testVersion {
  #   package = ifcopenshell;
  #   command = "IfcConvert --version";
  #   version = version;
  # };
}
