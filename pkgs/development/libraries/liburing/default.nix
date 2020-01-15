{ stdenv, fetchgit
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "liburing";
  version = "0.1";

  src = fetchgit {
    url    = "http://git.kernel.dk/liburing";
    rev    = "refs/tags/liburing-${version}";
    sha256 = "038iqsbm9bdmlwvmb899bc6g1rw5dalr990azynbvgn8qs5adysh";
  };

  patches = [

    # This patch re-introduces support for aarch64-linux, by adding the
    # necessary memory barrier primitives for it to work.
    #
    # Already upstream: remove when moving to the next version
    (fetchpatch {
      url    = "http://git.kernel.dk/cgit/liburing/patch/?id=0520db454c29f1d96cda6cf6cedeb93df65301e8";
      sha256 = "1i8133sb1imzxpplmhlhnaxkffgplhj40vanivc6clbibvhgwpq6";
    })

    # This patch shuffles the name of the io_uring memory barrier primitives.
    # They were using extremely common names by accident, which caused
    # namespace conflicts with many other projects using the same names. Note:
    # this does not change the user-visible API of liburing (liburing is
    # designed exactly to hide the necessary memory barriers when using the
    # io_uring syscall directly). It only changes the names of some internals.
    # The only reason this caused problems at all is because memory barrier
    # primitives are written as preprocessor defines, in a common header file,
    # which get included unilaterally.
    #
    # Already upstream: remove when moving to the next version
    (fetchpatch {
      url    = "http://git.kernel.dk/cgit/liburing/patch/?id=552c6a08d04c74d20eeaa86f535bfd553b352370";
      sha256 = "123d6jdqfy7b8aq9f6ax767n48hhbx6pln3nlrp623595i8zz3wf";
    })

    # Finally, this patch fixes the aarch64-linux support introduced by the
    # first patch, but which was _broken_ by the second patch, in a horrid
    # twist of fate: it neglected to change the names of the aarch64 barriers
    # appropriately.
    #
    # Already upstream: remove when moving to the next version
    (fetchpatch {
      url    = "http://git.kernel.dk/cgit/liburing/patch/?id=6e9dd0c8c50b5988a0c77532c9c2bd6afd4790d2";
      sha256 = "11mqa1bp2pdfqh08gpcd98kg7lh3rrng41b4l1wvhxdbvg5rfw9c";
    })

  ];

  separateDebugInfo = true;
  enableParallelBuilding = true;

  outputs = [ "out" "lib" "dev" "man" ];

  configurePhase = ''
    ./configure \
      --prefix=$out \
      --includedir=$dev/include \
      --libdir=$lib/lib \
      --mandir=$man/share/man \
  '';

  # Copy the examples into $out.
  postInstall = ''
    mkdir -p $out/bin
    cp ./examples/io_uring-cp examples/io_uring-test $out/bin
    cp ./examples/link-cp $out/bin/io_uring-link-cp
  '';

  meta = with stdenv.lib; {
    description = "Userspace library for the Linux io_uring API";
    homepage    = http://git.kernel.dk/cgit/liburing/;
    license     = licenses.lgpl21;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
