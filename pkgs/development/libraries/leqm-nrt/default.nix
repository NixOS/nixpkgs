{ lib
, stdenv
, fetchFromGitHub
, wafHook
, python3
, pkg-config
, dcpomatic
, ffmpeg
, libsndfile
}:

stdenv.mkDerivation rec {
  pname = "leqm-nrt";
  version = "0.20-cth";

  src = fetchFromGitHub {
    owner = "cth103";
    repo = "leqm-nrt";
    rev = "93ae9e6e4319a792cbfe5302dddc1b7781c55c76";
    sha256 = "08bsj2fp9waa3j11dqmn50w9lvhx960fmd5xcpjnxv3v0mkr7jsg";
  };

  postPatch = ''
    substituteInPlace wscript \
      --replace "this_version = " "this_version = 'v${version}' #" \
      --replace "last_version = " "last_version = 'v${version}' #"
  '';

  buildInputs = [
    ffmpeg
    libsndfile
  ];

  nativeBuildInputs = [
    wafHook
    python3
    pkg-config
  ];

  passthru.tests = {
    # Changes to leqm-nrt should basically always ensure dcpomatic continues to build.
    inherit dcpomatic;
  };

  meta = with lib; {
    description = "Implementation of Leq(M) measurement";
    homepage = "https://github.com/lucat/leqm-nrt";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ lukegb ];
  };
}
