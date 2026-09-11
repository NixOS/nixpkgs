{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  stdenv,

  glib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "darkdetect";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "albertosottile";
    repo = "darkdetect";
    rev = "v${version}";
    hash = "sha256-OOINgrgjSLr3L07E9zf1+mlTPr+7ZlgN3CfkWE8+LoE=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "darkdetect" ];

  postPatch = lib.optionalString (stdenv.hostPlatform.isLinux) ''
    substituteInPlace darkdetect/_linux_detect.py \
      --replace "'gsettings'" "'${glib.bin}/bin/gsettings'"
  '';

  meta = {
    description = "Detect OS Dark Mode from Python";
    homepage = "https://github.com/albertosottile/darkdetect";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
