{
  stdenv,
  microhs,
  writeTextDir,
}:

stdenv.mkDerivation {
  name = "microhs-hello-world";
  buildInputs = [ microhs ];

  src = writeTextDir "helloworld.hs" ''
    main :: IO ()
    main = putStrLn "Hello World"
  '';

  buildPhase = ''
    runHook preBuild
    mhs helloworld.hs -oExe
    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck
    ./Exe | grep "Hello World"
    runHook postCheck
  '';
  doCheck = true;

  installPhase = ''
    runHook preInstall
    touch $out
    runHook postInstall
  '';
}
