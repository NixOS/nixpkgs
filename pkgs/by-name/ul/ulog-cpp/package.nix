{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doctest,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ulog-cpp";
  version = "0-unstable-2025-06-19";

  src = fetchFromGitHub {
    owner = "PX4";
    repo = "ulog_cpp";
    rev = "4153a324d0c3fba73a4b9a375b3bed29e9a208a2";
    hash = "sha256-2YdhBcpDDu8XgL1PZudCYxt3nXNPpW/zu/crfdof4ow=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ doctest ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "C++ library for reading and writing ULog files";
    homepage = "https://github.com/PX4/ulog_cpp";
    platforms = lib.platforms.all;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
