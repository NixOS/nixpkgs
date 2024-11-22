{ lib
, fetchFromGitHub
, python3
, python3Packages
, makeWrapper
, installShellFiles
}:

python3Packages.buildPythonApplication rec {
  pname = "weevely";
  version = "4.0.2-unstable-2024-04-29";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "epinna";
    repo = "weevely3";
    rev = "3fe896a67af8c0b44f39f50fb7234812a9da2118";
    hash = "sha256-rUFwy6eoQQ8eQFcmOP+tCS6mKdWmRjeeyAqsc0TYCHU=";
  };

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  propagatedBuildInputs = with python3Packages; [
    dateutils
    mako
    prettytable
    pyopenssl
    pysocks
    pyyaml
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,share/weevely}
    installManPage weevely.1
    rm README.md CHANGELOG.md requirements.txt LICENSE weevely.1
    cp -a * $out/share/weevely/
    makeWrapper ${python3}/bin/python $out/bin/weevely \
      --add-flags "$out/share/weevely/weevely.py" \
      --prefix PYTHONPATH : ${python3Packages.makePythonPath propagatedBuildInputs}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Weaponized web shell";
    homepage = "https://github.com/epinna/weevely3";
    mainProgram = "weevely";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ d3vil0p3r ];
  };
}
