{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "font-droid-${version}";
  version = "2015-12-09";
  at = "2776afefa9e0829076cd15fdc41e7950e2ffab82";

  srcs = [
    (fetchurl {
      url = "https://github.com/google/fonts/raw/${at}/apache/droidsans/DroidSans.ttf";
      sha256 = "1yml18dm86rrkihb2zz0ng8b1j2bb14hxc1d3hp0998vsr9s1w4h";
    })
    (fetchurl {
      url = "https://github.com/google/fonts/raw/${at}/apache/droidsans/DroidSans-Bold.ttf";
      sha256 = "1z61hz92d3l1pawmbc6iwi689v8rr0xlkx59pl89m1g9aampdrmh";
    })
    (fetchurl {
      url = "https://github.com/google/fonts/raw/${at}/apache/droidsansmono/DroidSansMono.ttf";
      sha256 = "0rzspxg457q4f4cp2wz93py13lbnqbhf12q4mzgy6j30njnjwl9h";
    })
    (fetchurl {
      url = "https://github.com/google/fonts/raw/${at}/apache/droidserif/DroidSerif.ttf";
      sha256 = "1y7jzi7dz8j1yp8dxbmbvd6dpsck2grk3q1kd5rl7f31vlq5prj1";
    })
    (fetchurl {
      url = "https://github.com/google/fonts/raw/${at}/apache/droidserif/DroidSerif-Bold.ttf";
      sha256 = "1c61b423sn5nnr2966jdzq6fy8pw4kg79cr3nbby83jsly389f9b";
    })
    (fetchurl {
      url = "https://github.com/google/fonts/raw/${at}/apache/droidserif/DroidSerif-Italic.ttf";
      sha256 = "1bvrilgi0s72hiiv32hlxnzazslh3rbz8wgmsln0i9mnk7jr9bs0";
    })
    (fetchurl {
      url = "https://github.com/google/fonts/raw/${at}/apache/droidserif/DroidSerif-BoldItalic.ttf";
      sha256 = "052vlkmhy9c5nyk4byvhzya3y57fb09lqxd6spar6adf9ajbylgi";
    })
  ];

  phases = [ "unpackPhase" "installPhase" ];

  sourceRoot = "./";

  unpackCmd = ''
    ttfName=$(basename $(stripHash $curSrc))
    cp $curSrc ./$ttfName
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/droid
    cp *.ttf $out/share/fonts/droid
  '';

  meta = {
    description = "Droid Family fonts by Google Android";
    homepage = https://github.com/google/fonts;
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.all;
    maintainers = [];
  };
}
