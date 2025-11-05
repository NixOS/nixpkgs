{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchpatch2,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "xsstrike";
  version = "3.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "s0md3v";
    repo = "XSStrike";
    tag = version;
    hash = "sha256-6U0e9JkYYIt+APZ6B4+kNO/hcC3BAfrn+QXbCnLqpbs=";
  };

  patches = [
    (fetchpatch2 {
      # https://github.com/s0md3v/XSStrike/pull/435
      url = "https://github.com/s0md3v/XSStrike/commit/101ad7d789583e3aa99461e864377b0683d4f29c.patch";
      hash = "sha256-5ONL5nUyi/tEiINnVmmWbQd1vY8zNqS0ryFf/6k+7Lc=";
    })
  ];

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    tld
    fuzzywuzzy
    requests
  ];

  postPatch = ''
    substituteInPlace xsstrike.py \
      --replace-fail "sys.path[0] + '/db/" "'$out/${python3Packages.python.sitePackages}/db/"
    substituteInPlace core/wafDetector.py \
      --replace-fail "sys.path[0] + '/db/" "'$out/${python3Packages.python.sitePackages}/db/"

    substituteInPlace xsstrike.py \
      --replace-fail 'v3.1.5' 'v${version}'
  '';

  postInstall = ''
    mv $out/bin/xsstrike{.py,} 
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/xsstrike | head -2 | grep -F 'v${version}'
    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Most advanced XSS scanner";
    homepage = "https://github.com/s0md3v/XSStrike";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ letgamer ];
    mainProgram = "xsstrike";
  };
}
