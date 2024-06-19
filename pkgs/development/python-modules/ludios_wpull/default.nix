{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchPypi
, chardet
, dnspython
, html5-parser
, lxml
, namedlist
, psutil
, setuptools
, sqlalchemy
, tornado
, yapsy
, python
, pythonOlder
# Override Python packages using
# self: super: { pkg = super.pkg.overridePythonAttrs (oldAttrs: { ... }); }
# Applied after defaultOverrides
, packageOverrides ? self: super: {}
}:

let
  defaultOverrides = [
    # override the version of packages pinned in pyproject.toml
    (self: super: {
      sqlalchemy = super.sqlalchemy.overridePythonAttrs (oldAttrs: rec {
        version = "2.0.23";
        src = oldAttrs.src.override {
          inherit version;
          rev = "refs/tags/rel_${lib.replaceStrings [ "." ] [ "_" ] version}";
          hash = "sha256-UIQlYsiZk1fzxDxKHNTBL06Ua/xPZQ15H5coEdkWc90=";
        };
      });
    })
  ];
  py = python.override {
    # Put packageOverrides at the start so they are applied after defaultOverrides
    packageOverrides = lib.foldr lib.composeExtensions (self: super: { }) ([ packageOverrides ] ++ defaultOverrides);
  };
in with py.pkgs; buildPythonPackage rec {
  pname = "ludios_wpull";
  version = "5.0.3";

  disabled = pythonOlder "3.12";

  format = "pyproject";

  src = fetchFromGitHub {
    rev = version;
    owner = "ArchiveTeam";
    repo = "ludios_wpull";
    hash = "sha256-TAyqgp5KOvwXMzb66meVX1iPWQihb3nSCYmikt0xeOU=";
  };

  propagatedBuildInputs = [ chardet dnspython html5-parser lxml namedlist psutil setuptools py.pkgs.sqlalchemy tornado yapsy ];

  # Test suite has tests that fail on all platforms
  doCheck = false;

  meta = {
    description = "Web crawler; fork of wpull used by grab-site";
    homepage = "https://github.com/ArchiveTeam/ludios_wpull";
    license = lib.licenses.gpl3;
    broken = lib.versions.major tornado.version != "6";
  };
}
