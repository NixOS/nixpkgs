{ stdenv
, lib
, fetchurl
, libsndfile
, pkg-config
, python3
, wafHook
, pipewire
}:

stdenv.mkDerivation rec {
  pname = "lv2";
  version = "1.18.2";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://lv2plug.in/spec/${pname}-${version}.tar.bz2";
    sha256 = "sha256-TokfvHRMBYVb6136gugisUkX3Wbpj4K4Iw29HHqy4F4=";
  };

  nativeBuildInputs = [
    pkg-config
    wafHook
    python3
  ];

  buildInputs = [
    libsndfile
    python3
  ];

  wafConfigureFlags = [
    "--includedir=${placeholder "dev"}/include"
    "--bindir=${placeholder "dev"}/bin"
  ] ++ lib.optionals stdenv.isDarwin [
    "--lv2dir=${placeholder "out"}/lib/lv2"
  ];
  dontAddWafCrossFlags = true;

  passthru.tests = {
    inherit pipewire;
  };

  meta = with lib; {
    homepage = "https://lv2plug.in";
    description = "A plugin standard for audio systems";
    license = licenses.mit;
    maintainers = with maintainers; [ goibhniu ];
    platforms = platforms.unix;
  };
}
