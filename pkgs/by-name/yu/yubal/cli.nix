{
  yubal,
  deno,
  python312Packages,
  fetchPypi,
}:
with python312Packages;
let
  deno_wrapper = buildPythonPackage rec {
    pname = "deno";
    version = "2.8.2";

    propagatedBuildInputs = [
      deno
    ];

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-2XAQxgZqSol13Wy0R+IU2zOksBUUQ6c/dAs9Y5NcSr4=";
    };

    postPatch = ''
            python <<EOF
      from pathlib import Path

      p = Path("scripts/hatch_build.py")
      text = p.read_text()

      old = """deno = download_deno_bin(
                  Path(self.directory),
                  os.environ.get("DENO_VERSION", self.metadata.version),
                  zname,
              )"""

      new = """deno = Path("${deno}/bin/deno")"""

      p.write_text(text.replace(old, new))
      EOF
    '';

    pyproject = true;
    build-system = [ hatchling ];
  };
in
buildPythonPackage {
  pname = yubal.pname + "-cli";
  inherit (yubal) version src;
  sourceRoot = "source/packages/yubal";
  pyproject = true;

  build-system = [
    uv-build
  ];

  pythonImportsCheck = [ "yubal" ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.23,<0.12.0" "uv-build"
  '';

  dependencies = [
    ytmusicapi
    pydantic
    yt-dlp
    pathvalidate
    rapidfuzz
    mediafile
    httpx
    unidecode
    numpy_1
    deno_wrapper
  ];
}
