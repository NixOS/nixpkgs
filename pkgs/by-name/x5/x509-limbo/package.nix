{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonPackage {
  pname = "x509-limbo";
  version = "unstable-2024-09-25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "C2SP";
    repo = "x509-limbo";
    rev = "4d87f8fcb080ca175389dab8fac34ccb3821ad01";
    hash = "sha256-uPbynIRwpwogVXlZ2j16Ap1zeJfNbc4d8LDxcp2rXHs=";
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
