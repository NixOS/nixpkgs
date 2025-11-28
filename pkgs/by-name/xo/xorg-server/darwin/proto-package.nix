{ xorg-server }:
xorg-server.overrideAttrs (oldAttrs: {
  configureFlags = oldAttrs.configureFlags ++ [
    "--disable-xquartz"
    "--enable-xorg"
    "--enable-xvfb"
    "--enable-xnest"
    "--enable-kdrive"
  ];
  postInstall = ":"; # prevent infinite recursion
})
