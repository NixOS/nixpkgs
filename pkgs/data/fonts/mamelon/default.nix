<<<<<<< HEAD
{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation {
  pname = "Mamelon";
  version = "1";

  src = fetchzip {
    url = "https://moji-waku.com/download/mamelon_hireg.zip";
    hash = "sha256-ngnzxjWH8nagpDnSBHas0aVfGrOCjS5i6SS7loKi9E8=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/opentype
    mv *.otf $out/share/fonts/opentype

    runHook postInstall
  '';

  meta = {
    description = "Mamelon Hi-Regular";
    longDescription = ''
      マメロン Hi Regularは、デジタル時代の日常語と俗語の文章表現の視覚化と共有を目的とした書体です。令和2年の昨今、スマホやタブレット端末、PC環境では明朝体やゴシック体を用いることがもっぱら。そこに「丸形書体」という選択肢を導入することで、これまでアナログとデジタルの間で抜け落ちてしまっていた感情表現や、漢字が多いだけで苦痛と感じる状況に何かしらの変化が生まれることを期待しています。
    '';
    homepage = "https://moji-waku.com";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
||||||| parent of 78ed81bc7be (mamelon: init at 1)
=======
{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation {
  pname = "Mamelon-Hi-Regular";
  version = "1";

  src = fetchzip {
    url = "https://moji-waku.com/download/mamelon_hireg.zip";
    hash = "sha256-ngnzxjWH8nagpDnSBHas0aVfGrOCjS5i6SS7loKi9E8=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/opentype
    mv *.otf $out/share/fonts/opentype

    runHook postInstall
  '';

  meta = {
    description = "Mamelon Hi-Regular";
    longDescription = ''
      マメロン Hi Regularは、デジタル時代の日常語と俗語の文章表現の視覚化と共有を目的とした書体です。令和2年の昨今、スマホやタブレット端末、PC環境では明朝体やゴシック体を用いることがもっぱら。そこに「丸形書体」という選択肢を導入することで、これまでアナログとデジタルの間で抜け落ちてしまっていた感情表現や、漢字が多いだけで苦痛と感じる状況に何かしらの変化が生まれることを期待しています。
    '';
    homepage = "https://moji-waku.com";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = [ "elias-ainsworth" ];
  };
}
>>>>>>> 78ed81bc7be (mamelon: init at 1)
