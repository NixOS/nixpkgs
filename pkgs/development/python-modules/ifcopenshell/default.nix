# TODO format with nixpkgs (comma position ?)
{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, python3
, ifcopenshell
# python deps
, python3Packages
, setuptools
, build
, wheel
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

  nativeBuildInputs = [ python3 wheel build setuptools];

  pythonImportsCheck = [ "ifcopenshell" ];

  buildInputs = [
    ifcopenshell
    python3
  ];

  preConfigure = ''
    cd src/ifcopenshell-python
    # The build process is here: https://github.com/IfcOpenShell/IfcOpenShell/blob/v0.8.0/src/ifcopenshell-python/Makefile#L131
    # but we'd have to patch the copied pyproject.toml anyway, as the version is incorrect (even after their `make dist` btw), and the `where = ["dist"]` does not apply to us.
    # so let's just create it from scratch
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
    # these 2 files are wrapper over a C api. They are put in the python3.11 in the ifcopenshell cmake build process folder
    # because the default python3 is 3.11 at the time of writing this, but AFAIK there is nothing specific to 3.11 here.
    cp -v ${ifcopenshell.out}/lib/python3.11/site-packages/ifcopenshell/ifcopenshell_wrapper.py ./ifcopenshell/
    cp -v ${ifcopenshell.out}/lib/python3.11/site-packages/ifcopenshell/_ifcopenshell_wrapper.so ./ifcopenshell/
	# distutils cannot access anything outside the cwd, so hackishly swap out the README.md
	cp README.md ../README.bak
	cp ../../README.md README.md
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Open source IFC library and geometry engine, python bindings.";
    homepage = "http://ifcopenshell.org/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ fehnomenal ];
  };
}
