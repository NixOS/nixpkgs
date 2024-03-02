{lib
, stdenv
, fetchFromGitHub
, cmake

# for passthru.tests
, gst_all_1
, mpd
, ocamlPackages
, vlc
}:

stdenv.mkDerivation rec {
  pname = "faad2";
  version = "2.11.1";

  src = fetchFromGitHub {
    owner = "knik0";
    repo = "faad2";
    rev = version;
    hash = "sha256-E6oe7yjYy1SJo8xQkyUk1sSucKDMPxwUFVSAyrf4Pd8=";
  };

  outputs = [ "out" "dev" "man" ];

  nativeBuildInputs = [ cmake ];

  passthru.tests = {
    inherit mpd vlc;
    inherit (gst_all_1) gst-plugins-bad;
    ocaml-faad = ocamlPackages.faad;
  };

  meta = with lib; {
    description = "An open source MPEG-4 and MPEG-2 AAC decoder";
    homepage = "https://sourceforge.net/projects/faac/";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ codyopel ];
    mainProgram = "faad";
    platforms   = platforms.all;
  };
}
