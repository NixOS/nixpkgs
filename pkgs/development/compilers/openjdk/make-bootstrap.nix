{ runCommand, openjdk }:

let arch = if openjdk.system == "x86_64-linux" then "amd64" else "i386"; in

runCommand "${openjdk.name}-bootstrap" {} ''
  mkdir -p $out/bin
  mkdir -p $out/lib
  mkdir -p $out/jre/lib/{security,ext,${arch}/{jli,server,headless}}
  cp ${openjdk}/bin/{idlj,ja{va{,c,p,h},r},rmic} $out/bin
  cp ${openjdk}/lib/tools.jar $out/lib
  cp ${openjdk}/jre/lib/{meta-index,{charsets,jce,jsse,rt,resources}.jar,currency.data} $out/jre/lib
  cp ${openjdk}/jre/lib/security/java.security $out/jre/lib/security
  cp ${openjdk}/jre/lib/ext/{meta-index,sunjce_provider.jar} $out/jre/lib/ext
  cp ${openjdk}/jre/lib/${arch}/{jvm.cfg,lib{awt,java,verify,zip,nio,net}.so} $out/jre/lib/${arch}
  cp ${openjdk}/jre/lib/${arch}/jli/libjli.so $out/jre/lib/${arch}/jli
  cp ${openjdk}/jre/lib/${arch}/server/libjvm.so $out/jre/lib/${arch}/server
  cp ${openjdk}/jre/lib/${arch}/headless/libmawt.so $out/jre/lib/${arch}/headless
  cp -a ${openjdk}/include $out
''
