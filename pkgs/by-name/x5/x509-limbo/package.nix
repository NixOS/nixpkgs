{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonPackage {
  pname = "x509-limbo";
  version = "unstable-2024-03-13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "C2SP";
    repo = "x509-limbo";
    rev = "a04fb05cf132e1405f71c12616cf0aead829909a";
    hash = "sha256-TA4ciHkXg/RKzcIs2bwpx7CxsQDyQMG636Rr74xPsBA=";
  };

  dependencies = with python3.pkgs; [
    flit-core

    requests
    pydantic
    jinja2
    cryptography
    pyopenssl
    pyyaml
    certvalidator
    certifi
  ];

  postInstall = ''
    mkdir -p $out/share
    cp limbo.json $out/share/

    wrapProgram $out/bin/limbo \
      --append-flags "--limbo $out/share/limbo.json"
  '';

  meta = with lib; {
    homepage = "https://x509-limbo.com/";
    description = "Suite of testvectors for X.509 certificate path validation and tools for building them";
    mainProgram = "limbo";

    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ baloo ];
  };
}
