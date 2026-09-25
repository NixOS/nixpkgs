{
  pname,
  version,
  src,
  meta,
  appimageTools,
  noto-fonts-cjk-sans-static,
  writeText,
}:

let
  appimageContents = appimageTools.extract {
    inherit pname version src;
    postExtract = ''
      patchelf --replace-needed libtiff.so.5 libtiff.so $out/opt/wechat/wechat
    '';
  };

  # WeChat (which statically links Qt and FreeType) renders the variable Noto
  # CJK fonts at their default Thin weight in places such as the message input
  # box. Hide them from WeChat and provide the static fonts instead.
  fontsConf = writeText "wechat-fonts.conf" ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
    <fontconfig>
      <include ignore_missing="yes">/etc/fonts/fonts.conf</include>
      <dir>${noto-fonts-cjk-sans-static}/share/fonts</dir>
      <selectfont>
        <rejectfont>
          <glob>*/NotoSansCJK-VF.otf.ttc</glob>
          <glob>*/NotoSansMonoCJK-VF.otf.ttc</glob>
          <glob>*/NotoSerifCJK-VF.otf.ttc</glob>
        </rejectfont>
      </selectfont>
    </fontconfig>
  '';
in
appimageTools.wrapAppImage {
  inherit pname version meta;

  src = appimageContents;

  profile = ''
    export FONTCONFIG_FILE=${fontsConf}
  '';

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    cp ${appimageContents}/wechat.desktop $out/share/applications/
    mkdir -p $out/share/icons/hicolor/256x256/apps
    cp ${appimageContents}/wechat.png $out/share/icons/hicolor/256x256/apps/

    substituteInPlace $out/share/applications/wechat.desktop --replace-fail AppRun wechat
  '';
}
