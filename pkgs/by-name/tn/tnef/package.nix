{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.4.18";
  pname = "tnef";

  src = fetchFromGitHub {
    owner = "verdammelt";
    repo = "tnef";
    rev = finalAttrs.version;
    sha256 = "104g48mcm00bgiyzas2vf86331w7bnw7h3bc11ib4lp7rz6zqfck";
  };

  patches = [
    # Fix gcc-15 build failure: https://github.com/verdammelt/tnef/pull/49
    (fetchpatch {
      name = "gcc-15.patch";
      url = "https://github.com/verdammelt/tnef/commit/86bfa75cfacbe71c8d5282fa0065981b4544c5ad.patch";
      hash = "sha256-iWQop57riqwDLVi5Ba5s4f34lGXgvKO3ZMTgWbAoRIY=";
    })
  ];

  doCheck = true;

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "Unpacks MIME attachments of type application/ms-tnef";
    longDescription = ''
      TNEF is a program for unpacking MIME attachments of type "application/ms-tnef". This is a Microsoft only attachment.

      Due to the proliferation of Microsoft Outlook and Exchange mail servers, more and more mail is encapsulated into this format.

      The TNEF program allows one to unpack the attachments which were encapsulated into the TNEF attachment. Thus alleviating the need to use Microsoft Outlook to view the attachment.
    '';
    homepage = "https://github.com/verdammelt/tnef";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = lib.platforms.all;
    mainProgram = "tnef";
  };
})
