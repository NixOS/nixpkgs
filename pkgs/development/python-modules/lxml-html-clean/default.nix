{
  lib,
  fetchFromGitHub,
  unittestCheckHook,
  pythonOlder,
  setuptools,
}:

let
  overlays = [
    (
      self: super:
      let
        libxml2_13_8 = super.libxml2.overrideAttrs (oldAttrs: {
          version = "2.13.8";
          src = super.fetchurl {
            url = "mirror://gnome/sources/libxml2/2.13/libxml2-2.13.8.tar.xz";
            hash = "sha256-J3KUyzMRmrcbK8gfL0Rem8lDW4k60VuyzSsOhZoO6Eo=";
          };
        });
      in
      {
        libxml2 = libxml2_13_8;
      }
    )
  ];

  pkgs = import <nixpkgs> { overlays = overlays; };
in
pkgs.python3Packages.buildPythonPackage rec {
  pname = "lxml-html-clean";
  version = "0.4.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fedora-python";
    repo = "lxml_html_clean";
    tag = version;
    hash = "sha256-KGUFRbcaeDcX2jyoyyZMZsVTbN+h8uy+ugcritkZe38=";
  };

  build-system = [ setuptools ];

  dependencies = [
    (pkgs.python3Packages.lxml)
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "lxml_html_clean" ];

  meta = with lib; {
    description = "Separate project for HTML cleaning functionalities copied from lxml.html.clean";
    homepage = "https://github.com/fedora-python/lxml_html_clean/";
    changelog = "https://github.com/fedora-python/lxml_html_clean/blob/${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
