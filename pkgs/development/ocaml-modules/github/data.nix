{
  buildDunePackage,
  github,
  yojson,
  atdgen,
  atdgen-runtime,
}:

buildDunePackage {
  pname = "github-data";
  inherit (github) version src;

  postPatch = ''
    substituteInPlace lib_data/dune --replace-warn 'atdgen)' 'atdgen-runtime)'
  '';

  nativeBuildInputs = [
    atdgen
  ];

  propagatedBuildInputs = [
    yojson
    atdgen-runtime
  ];

  meta = github.meta // {
    description = "GitHub APIv3 data library";
  };
}
