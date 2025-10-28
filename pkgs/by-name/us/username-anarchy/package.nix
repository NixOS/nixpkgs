{
  lib,
  stdenv,
  fetchFromGitHub,
  ruby,
}:

stdenv.mkDerivation {
  pname = "username-anarchy";
  version = "0.5";

  src = fetchFromGitHub {
    rev = "d5e653f0ab31d8d3fff79b2986f6ef9624d80fba";
    owner = "urbanadventurer";
    repo = "username-anarchy";
    hash = "sha256-1he1FzNc6y7jm/UwedG81z5QGehh2qsd1QkAsIXwrag=";
  };

  buildInputs = [ ruby ];

  preInstall = ''
    mkdir -p $out/bin
    install -Dm 555 format-plugins.rb $out/bin/
    install -Dm 555 username-anarchy $out/bin/
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
