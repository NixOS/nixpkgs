{ stdenv, fetchurl, cmake, boost, ruby_1_9, ignition, tinyxml
  , name ? "sdformat-${version}"
  , version ? "4.0.0" # versions known to work with this expression include 3.7.0
  , srchash-sha256 ? "b0f94bb40b0d83e35ff250a7916fdfd6df5cdc1e60c47bc53dd2da5e2378163e"
  , ...
  }:

let 
  ruby = ruby_1_9;
in
stdenv.mkDerivation rec {
  src = fetchurl { 
      url = "http://osrf-distributions.s3.amazonaws.com/sdformat/releases/${name}.tar.bz2";
      sha256 = srchash-sha256;
  };

  inherit name;

  enableParallelBuilding = true;
  buildInputs = [
    cmake boost ruby ignition.math2 tinyxml
  ];
}
