{
  buildPerlModule,
  remctl,
  TestPod,
}:

buildPerlModule {
  pname = "NetRemctl";

  inherit (remctl) meta src version;

  postPatch = ''
    cp -R tests/tap/perl/Test perl/t/lib
<<<<<<< HEAD
    rm perl/t/backend/options.t
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    cd perl
  '';

  buildInputs = [ remctl ];

  checkInputs = [ TestPod ];
}
