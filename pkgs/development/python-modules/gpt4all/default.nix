{
  lib,
  basepkg,
  buildPythonPackage,
  stdenv,
  requests,
  tqdm,
  typing-extensions,
  pythonOlder,
  setuptools,
}:
let
  gpt4all-backend = stdenv.mkDerivation {
    pname = "gpt4all-backend";
    inherit (basepkg)
      src
      version
      cmakeFlags
      nativeBuildInputs
      buildInputs
      ;

    sourceRoot = "${basepkg.src.name}/gpt4all-backend";
    installPhase = ''
      cp -r ./ $out
    '';
  };
in
buildPythonPackage {
  pname = "gpt4all";
  inherit (basepkg) src version;
  sourceRoot = "${basepkg.src.name}/gpt4all-bindings/python";
  pyproject = true;

  patches = [ ./setup_fixup.patch ];
  disabled = pythonOlder "3.8";

  propagatedBuildInputs = [
    requests
    tqdm
  ] ++ lib.optionals (pythonOlder "3.11") [ typing-extensions ];

  build-system = [ setuptools ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'SRC_CLIB_DIRECTORY = ' 'SRC_CLIB_DIRECTORY = "${gpt4all-backend}" #' \
      --replace-fail 'SRC_CLIB_BUILD_DIRECTORY = ' 'SRC_CLIB_BUILD_DIRECTORY = "${gpt4all-backend}/" #' \
      --replace-fail 'DEST_CLIB_BUILD_DIRECTORY = ' 'DEST_CLIB_BUILD_DIRECTORY = os.path.join(DEST_CLIB_DIRECTORY, "build") #'
  '';

  # Python tests are disabled as all of them requires internet connection in order to download LLM models

  pythonImportsCheck = [ "gpt4all" ];

  meta = with lib; {
    description = "Run Local LLMs on Any Device.";
    maintainers = with maintainers; [ litchipi ];
    license = with licenses; [ mit ];
    homepage = "https://www.nomic.ai/gpt4all";
  };
}
