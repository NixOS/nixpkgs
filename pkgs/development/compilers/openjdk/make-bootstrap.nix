{ runCommand, openjdk, nukeReferences }:

let arch = openjdk.architecture; in

runCommand "${openjdk.name}-bootstrap.tar.xz" {} ''
  mkdir -p openjdk-bootstrap/bin
  mkdir -p openjdk-bootstrap/lib
  mkdir -p openjdk-bootstrap/jre/lib/{security,ext,${arch}/{jli,server,client,headless}}
  cp ${openjdk}/bin/{idlj,ja{va{,c,p,h},r},rmic} openjdk-bootstrap/bin
  cp ${openjdk}/lib/tools.jar openjdk-bootstrap/lib
  cp ${openjdk}/jre/lib/{meta-index,{charsets,jce,jsse,rt,resources}.jar,currency.data} openjdk-bootstrap/jre/lib
  cp ${openjdk}/jre/lib/security/java.security openjdk-bootstrap/jre/lib/security
  cp ${openjdk}/jre/lib/ext/{meta-index,sunjce_provider.jar} openjdk-bootstrap/jre/lib/ext
  cp ${openjdk}/jre/lib/${arch}/{jvm.cfg,lib{awt,java,verify,zip,nio,net}.so} openjdk-bootstrap/jre/lib/${arch}
  cp ${openjdk}/jre/lib/${arch}/jli/libjli.so openjdk-bootstrap/jre/lib/${arch}/jli
  cp ${openjdk}/jre/lib/${arch}/server/libjvm.so openjdk-bootstrap/jre/lib/${arch}/server
  cp ${openjdk}/jre/lib/${arch}/client/libjvm.so openjdk-bootstrap/jre/lib/${arch}/client ||
    rmdir openjdk-bootstrap/jre/lib/${arch}/client
  cp ${openjdk}/jre/lib/${arch}/headless/libmawt.so openjdk-bootstrap/jre/lib/${arch}/headless
  cp -a ${openjdk}/include openjdk-bootstrap

  chmod -R +w openjdk-bootstrap
  find openjdk-bootstrap -print0 | xargs -0 ${nukeReferences}/bin/nuke-refs

  tar cv openjdk-bootstrap | xz > $out
''
