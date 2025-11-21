{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  installShellFiles,
  argcomplete,
  pytestCheckHook,
  p7zip,
  cabextract,
  zip,
  lzip,
  zpaq,
  gnutar,
  unar, # Free alternative to unrar
  gnugrep,
  diffutils,
  file,
  gzip,
  bzip2,
  xz,
}:

let
  compression-utilities = [
    p7zip
    gnutar
    unar
    cabextract
    zip
    lzip
    zpaq
    gzip
    gnugrep
    diffutils
    bzip2
    file
    xz
  ];
in
buildPythonPackage rec {
  pname = "patool";
  version = "4.0.1";
  format = "setuptools";

  #pypi doesn't have test data
  src = fetchFromGitHub {
    owner = "wummel";
    repo = "patool";
    tag = version;
    hash = "sha256-KAOJi8vUP9kPa++dLEXf3mwrv1kmV7uDZmtvngPxQ90=";
  };

  postPatch = ''
    substituteInPlace patoolib/util.py \
      --replace-fail 'path = os.environ.get("PATH", os.defpath)' 'path = os.environ.get("PATH", os.defpath) + ":${lib.makeBinPath compression-utilities}"'
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd patool \
      --bash <(${argcomplete}/bin/register-python-argcomplete -s bash $out/bin/patool) \
      --fish <(${argcomplete}/bin/register-python-argcomplete -s fish $out/bin/patool) \
      --zsh <(${argcomplete}/bin/register-python-argcomplete -s zsh $out/bin/patool)
  '';

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [ pytestCheckHook ] ++ compression-utilities;

  disabledTests = [
    "test_unzip"
    "test_unzip_file"
    "test_zip"
    "test_zip_file"
    "test_7z"
    "test_7z_file"
    "test_7za_file"
    "test_p7azip"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ "test_ar" ];

  meta = {
    description = "Portable archive file manager";
    mainProgram = "patool";
    homepage = "https://wummel.github.io/patool/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ marius851000 ];
  };
}
