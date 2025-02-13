{
  fetchFromGitHub,
  gnat,
  gprbuild,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "template-parser";
  version = "25.0.0";

  src = fetchFromGitHub {
    owner = "AdaCore";
    repo = "templates-parser";
    rev = "v${version}";
    sha256 = "sha256-92qjHZKFwOCwcMOXjMN3dmrHYOi6AGJT3qCXW9Ikdo4=";
  };

  nativeBuildInputs = [
    gnat
    gprbuild
  ];

  makeFlags = [
    "prefix=$(out)"
  ];

  meta = with lib; {
    description = "AWS templates engine.";
    homepage = "https://github.com/AdaCore/templates-parser";
    maintainers = with maintainers; [ felixsinger ];
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
