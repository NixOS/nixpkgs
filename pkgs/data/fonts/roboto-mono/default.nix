{ stdenv, fetchurl }:

let
  # last commit on the directory containing the fonts in the upstream repository
  commit = "883939708704a19a295e0652036369d22469e8dc";
in
stdenv.mkDerivation rec {
  name = "roboto-mono-${version}";
  version = "2016-01-11";

  srcs = [
    (fetchurl {
      url = "https://raw.githubusercontent.com/google/fonts/${commit}/apache/robotomono/RobotoMono-Regular.ttf";
      sha256 = "0r6g1xydy824xbbjilq6pvrv8611ga3q1702v5jj1ly5np6gpddz";
    })
    (fetchurl {
      url = "https://raw.githubusercontent.com/google/fonts/${commit}/apache/robotomono/RobotoMono-Bold.ttf";
      sha256 = "0x9qnrbd7hin873wjzrl6798bvakixd86qdw0z5b4sm56f7fjl32";
    })
    (fetchurl {
      url = "https://raw.githubusercontent.com/google/fonts/${commit}/apache/robotomono/RobotoMono-Italic.ttf";
      sha256 = "17aia6hgpjvvrl79y0f67ncr5y1nhyxj0dzqwdg3dycsa4kij59q";
    })
    (fetchurl {
      url = "https://raw.githubusercontent.com/google/fonts/${commit}/apache/robotomono/RobotoMono-BoldItalic.ttf";
      sha256 = "05gqfnps6qzxgyxrrmkmw0by3j88lf88v67n8jgi2chhhm0sw40q";
    })
    (fetchurl {
      url = "https://raw.githubusercontent.com/google/fonts/${commit}/apache/robotomono/RobotoMono-Medium.ttf";
      sha256 = "0ww96qd0cyj3waxf7a98hyd4cp8snajjvjmbhr66zilql8ylfzk0";
    })
    (fetchurl {
      url = "https://raw.githubusercontent.com/google/fonts/${commit}/apache/robotomono/RobotoMono-MediumItalic.ttf";
      sha256 = "1n2cvvcpwm68lazfh3s3xhj4mrc01x84mi2ackwf8ahd95fk9p5y";
    })
    (fetchurl {
      url = "https://raw.githubusercontent.com/google/fonts/${commit}/apache/robotomono/RobotoMono-Light.ttf";
      sha256 = "0na2sxz3n1km1ryz002spfa65d91fm48x0qcda2ac0rly7dgaqjf";
    })
    (fetchurl {
      url = "https://raw.githubusercontent.com/google/fonts/${commit}/apache/robotomono/RobotoMono-LightItalic.ttf";
      sha256 = "171fr8wsbmvfllsbmb9pcdax2qfzhbqzyxfn5bcrz9kx5k9x6198";
    })
    (fetchurl {
      url = "https://raw.githubusercontent.com/google/fonts/${commit}/apache/robotomono/RobotoMono-Thin.ttf";
      sha256 = "0pv54afyprajb16ksm5vklc1q76iv72v427wgamqzrzyvxgn6ymj";
    })
    (fetchurl {
      url = "https://raw.githubusercontent.com/google/fonts/${commit}/apache/robotomono/RobotoMono-ThinItalic.ttf";
      sha256 = "1ziyysl09z24l735y940g92rqhn9v4npwqzajj9m1kn0xz21r1aw";
    })
  ];

  sourceRoot = "./";

  unpackCmd = ''
    ttfName=$(basename $(stripHash $curSrc))
    cp $curSrc ./$ttfName
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp -a *.ttf $out/share/fonts/truetype/
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "1rd3qql779dn9nl940hf988lvv4gfy5llgrlfqq0db0c22b2yfng";

  meta = {
    homepage = https://www.google.com/fonts/specimen/Roboto+Mono;
    description = "Google Roboto Mono fonts";
    longDescription = ''
      Roboto Mono is a monospaced addition to the Roboto type family. Like
      the other members of the Roboto family, the fonts are optimized for
      readability on screens across a wide variety of devices and reading
      environments. While the monospaced version is related to its variable
      width cousin, it doesn't hesitate to change forms to better fit the
      constraints of a monospaced environment. For example, narrow glyphs
      like 'I', 'l' and 'i' have added serifs for more even texture while
      wider glyphs are adjusted for weight. Curved caps like 'C' and 'O'
      take on the straighter sides from Roboto Condensed.
    '';
    license = stdenv.lib.licenses.asl20;
    maintainers = [ stdenv.lib.maintainers.romildo ];
    platforms = stdenv.lib.platforms.all;
  };
}
