{
  lib,
  stdenv,
  fetchFromGitHub,
  ruby,
}:

stdenv.mkDerivation {
  pname = "username-anarchy";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "urbanadventurer";
    repo = "username-anarchy";
    tag = "v0.6";
    hash = "sha256-46hl1ynA/nc2R70VHhOqbux6B2hwiJWs/sf0ZRwNFf0=";
  };

  buildInputs = [ ruby ];

  preInstall = ''
    mkdir -p $out/bin
    install -Dm 555 format-plugins.rb $out/bin/
    install -Dm 555 username-anarchy $out/bin/
  '';

  postPatch = ''
    # Add shebang line to make the script executable
      sed -i -e '1i#!/usr/bin/env ruby' format-plugins.rb
  '';

  meta = with lib; {
    homepage = "https://github.com/urbanadventurer/username-anarchy/";
    description = "Username generator tool for penetration testing";
    license = licenses.mit;
    maintainers = [ maintainers.akechishiro ];
    platforms = platforms.unix;
    mainProgram = "username-anarchy";
  };
}
