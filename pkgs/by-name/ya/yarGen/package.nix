{
  lib,
  python3,
  fetchFromGitHub,
  fetchpatch,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "yarGen";
  version = "0.23.4";
  format = "other";

  src = fetchFromGitHub {
    owner = "Neo23x0";
    repo = "yarGen";
    rev = version;
    sha256 = "6PJNAeeLAyUlZcIi0g57sO1Ex6atn7JhbK9kDbNrZ6A=";
  };

  patches = [
    # https://github.com/Neo23x0/yarGen/pull/33
    (fetchpatch {
      name = "use-built-in-scandir.patch";
      url = "https://github.com/Neo23x0/yarGen/commit/cae14ac8efeb5536885792cae99d1d0f7fb6fde3.patch";
      sha256 = "0z6925r7n1iysld5c8li5nkm1dbxg8j7pn0626a4vic525vf8ndl";
    })
    # https://github.com/Neo23x0/yarGen/pull/34
    (fetchpatch {
      name = "use-cwd-for-abspath.patch";
      url = "https://github.com/Neo23x0/yarGen/commit/441dafb702149f5728c2c6736fc08741a46deb26.patch";
      sha256 = "lNp3oC2BM7tBzN4AetvPr+xJLz6KkZxQmsldeZaxJQU=";
    })
  ];

  postPatch = ''
    substituteInPlace yarGen.py \
      --replace "./3rdparty/strings.xml" "$out/share/yarGen/3rdparty/strings.xml"
  '';

  installPhase = ''
    runHook preInstall

    install -Dt "$out/bin" yarGen.py
    install -Dt "$out/share/yarGen/3rdparty" 3rdparty/strings.xml

    runHook postInstall
  '';

  propagatedBuildInputs = with python3.pkgs; [
    pefile
    lxml
  ];

  meta = with lib; {
    description = "Generator for YARA rules";
    mainProgram = "yarGen.py";
    homepage = "https://github.com/Neo23x0/yarGen";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
