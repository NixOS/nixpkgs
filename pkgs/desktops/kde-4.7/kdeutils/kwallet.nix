{ kde, kdelibs }:

kde {
  buildInputs = [ kdelibs ];

  meta = {
    description = "KDE Wallet (password storage) management tool";
  };
}
