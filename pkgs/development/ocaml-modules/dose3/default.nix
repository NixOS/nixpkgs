{ lib, buildDunePackage, fetchFromGitLab
, camlzip, ocamlgraph, parmap, re, stdlib-shims
, base64, bz2, ocaml_extlib, cudf
, dpkg, git, ocaml, ounit, python39, python39Packages
}:

buildDunePackage rec {
  pname = "dose3";
  version = "7.0.0";

  src = fetchFromGitLab {
    owner = "irill";
    repo = "dose3";
    rev = version;
    sha256 = "sha256-K0fYSAWV48Rers/foDrEIqieyJ0PvpXkuYrFrZGBkkE=";
  };

  minimalOCamlVersion = "4.03";
  useDune2 = true;

  buildInputs = [
    parmap
  ];

  propagatedBuildInputs = [
    base64
    bz2
    camlzip
    cudf
    ocaml_extlib
    ocamlgraph
    re
    stdlib-shims
  ];

  checkInputs = [
    dpkg                      # Replaces: conf-dpkg
    git
    ounit
    python39                  # Replaces: conf-python-3
    python39Packages.pyyaml   # Replaces: conf-python3-yaml
  ];
  doCheck = false; # Tests are failing.
                   # To enable tests use: lib.versionAtLeast ocaml.version "4.04";

  meta = with lib; {
    description = "Dose library (part of Mancoosi tools)";
    downloadPage = "https://gitlab.com/irill/dose3/";
    homepage = "https://www.mancoosi.org/software/";
    license = licenses.lgpl3Plus;
    longDescription = ''
      The dose suite provides libraries for handling package meta-data, and various tools for analyzing package relationships in a large package repository.
      * dose-builddebcheck checks, given a collection of source package stanzas and a collection of binary package stanzas of Debian packages, whether the build-dependencies of each source package can be satisfied by the binary packages.
      * dose-distcheck checks for every package of a distribution whether it is possible to satisfy its dependencies and conflicts within this distribution.
      * ceve, a general metadata parser supporting different input formats (Debian, rpm, and others) and different output formats.
      * dose-outdated, a Debian-specific tool for finding packages that are not installable with respect to a package repository, and that can only be made installable again by fixing the package itself.
      * dose-challenged, a Debian-specific tool for checking which packages will certainly become uninstallable when some existing package is upgraded to a newer version.
      * dose-deb-coinstall, a Debian-specific tool for checking whether a set of packages can be installed all together.
    '';
  };
}
