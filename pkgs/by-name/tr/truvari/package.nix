{
  lib,
  fetchFromGitHub,
  python3Packages,
  runtimeShell,
  bcftools,
  htslib,
}:

let
  ssshtest = fetchFromGitHub {
    owner = "ryanlayer";
    repo = "ssshtest";
    rev = "d21f7f928a167fca6e2eb31616673444d15e6fd0";
    hash = "sha256-zecZHEnfhDtT44VMbHLHOhRtNsIMWeaBASupVXtmrks=";
  };
in
python3Packages.buildPythonApplication rec {
  pname = "truvari";
  version = "4.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ACEnglish";
    repo = "truvari";
    rev = "v${version}";
    hash = "sha256-SFBVatcVavBfQtFbBcXifBX3YnKsxJS669vCcyjsBA4=";
  };

  postPatch = ''
    substituteInPlace truvari/utils.py \
      --replace "/bin/bash" "${runtimeShell}"
    patchShebangs repo_utils/test_files
  '';

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = with python3Packages; [
    pywfa
    rich
    edlib
    pysam
    intervaltree
    joblib
    numpy
    pytabix
    bwapy
    pandas
    pyabpoa
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      bcftools
      htslib
    ])
  ];

  pythonImportsCheck = [ "truvari" ];

  nativeCheckInputs = [
    bcftools
    htslib
  ]
  ++ (with python3Packages; [
    coverage
  ]);

  checkPhase = ''
    runHook preCheck

    ln -s ${ssshtest}/ssshtest .
    bash repo_utils/truvari_ssshtests.sh

    runHook postCheck
  '';

  meta = with lib; {
    description = "Structural variant comparison tool for VCFs";
    homepage = "https://github.com/ACEnglish/truvari";
    changelog = "https://github.com/ACEnglish/truvari/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [
      natsukium
      scalavision
    ];
    longDescription = ''
      Truvari is a benchmarking tool for comparison sets of SVs.
      It can calculate the recall, precision, and f-measure of a
      vcf from a given structural variant caller. The tool
      is created by Spiral Genetics.
    '';
  };
}
