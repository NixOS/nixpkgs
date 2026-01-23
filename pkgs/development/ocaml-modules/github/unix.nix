{
  buildDunePackage,
  fetchpatch,
  github,
  cohttp,
  cohttp-lwt-unix,
  stringext,
  cmdliner,
  lwt,
}:

buildDunePackage {
  pname = "github-unix";
  inherit (github) version src;

  patches = [
    # Compatibility with yojson 3.0
    (fetchpatch {
      url = "https://github.com/mirage/ocaml-github/commit/487d7d413363921a8ffbb941610c2f71c811add8.patch";
      hash = "sha256-ThCsWRQKmlRg7rk8tlorsO87v8RWnBvocHDvgg/WWMA=";
    })
  ];

  postPatch = ''
    substituteInPlace unix/dune --replace 'github bytes' 'github'
  '';

  propagatedBuildInputs = [
    github
    cohttp
    cohttp-lwt-unix
    stringext
    cmdliner
    lwt
  ];

  meta = github.meta // {
    description = "GitHub APIv3 Unix library";
  };
}
