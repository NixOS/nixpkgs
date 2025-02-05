{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  pkg-config,
  taglib,
  zlib,
}:

buildDunePackage rec {
  pname = "taglib";
  version = "0.3.10";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-taglib";
    rev = "v${version}";
    sha256 = "sha256-tAvzVr0PW1o0kKFxdi/ks4obqnyBm8YfiiFupXZkUho=";
  };

  minimalOCamlVersion = "4.05.0"; # Documented version 4.02.0. 4.05.0 actually required.

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    taglib
    zlib
  ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-taglib";
    description = "Bindings for the taglib library which provides functions for reading tags in headers of audio files";
    license = with licenses; [
      lgpl21Plus
      "link-exception"
    ]; # GNU Library Public License 2 Linking Exception
    maintainers = with maintainers; [ dandellion ];
  };
}
