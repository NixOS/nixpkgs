{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  libyaml,
  testers,
  yx,
}:
stdenv.mkDerivation rec {
  pname = "yx";
  version = "1.0.2";

  src = fetchFromGitLab {
    owner = "tomalok";
    repo = "yx";
    rev = version;
    hash = "sha256-uuso+hsmdsB7VpIRKob8rfMaWvRMCBHvCFnYrHPC6iw=";
  };

  patches = [
    # https://gitlab.com/tomalok/yx/-/issues/2
    ./0001-Don-t-strip-binary-when-installing.patch
    (fetchpatch {
      # https://gitlab.com/tomalok/yx/-/merge_requests/10
      url = "https://gitlab.com/tomalok/yx/-/commit/5747ca40f4b0acb56d67fd29a818734d7b19d61a.patch";
      hash = "sha256-0tNtkq1tZ96Ag5EJfUfDao/QxpRB4Jadop3OPBvhnlo=";
    })
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  strictDeps = true;

  buildInputs = [ libyaml ];

  doCheck = true;

  passthru.tests.version = testers.testVersion {
    package = yx;
    command = "${meta.mainProgram} -v";
    version = "v${yx.version}";
  };

  meta = with lib; {
    description = "YAML Data Extraction Tool";
    homepage = "https://gitlab.com/tomalok/yx";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ twz123 ];
    mainProgram = "yx";
  };
}
