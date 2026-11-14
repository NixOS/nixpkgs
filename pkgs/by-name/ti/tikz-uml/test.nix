{
  runCommand,
  tikz-uml,
  texliveSmall,
}:
runCommand "test.pdf"
  {
    nativeBuildInputs = [ (texliveSmall.withPackages (_: [ tikz-uml ])) ];
    strictDeps = true;
  }
  ''
    cat >test.tex <<EOF
    \documentclass[a4paper,11pt, svgnames]{article}
    \usepackage{tikz-uml}

    \textwidth 18.5cm
    \textheight 25.5cm
    \hoffset=-2.9cm
    \voffset=-2.9cm

    \sloppy
    \hyphenpenalty 10000000

    \date{}
    \title{}
    \author{}


    \begin{document}

    \begin{center}
    \begin{tikzpicture}
    \begin{umlseqdiag}
    \umlactor[class=A]{a}
    \umldatabase[class=B, fill=blue!20]{b}
    \umlmulti[class=C]{c}
    \umlobject[class=D]{d}
    \begin{umlcall}[op=opa(), type=synchron, return=0]{a}{b}
    \begin{umlfragment}
    \begin{umlcall}[op=opb(), type=synchron, return=1]{b}{c}
    \begin{umlfragment}[type=alt, label=condition, inner xsep=8, fill=green!10]
    \begin{umlcall}[op=opc(), type=asynchron, fill=red!10]{c}{d}
    \end{umlcall}
    \begin{umlcall}[type=return]{c}{b}
    \end{umlcall}
    \umlfpart[default]
    \begin{umlcall}[op=opd(), type=synchron, return=3]{c}{d}
    \end{umlcall}
    \end{umlfragment}
    \end{umlcall}
    \end{umlfragment}
    \begin{umlfragment}
    \begin{umlcallself}[op=ope(), type=synchron, return=4]{b}
    \begin{umlfragment}[type=assert]
    \begin{umlcall}[op=opf(), type=synchron, return=5]{b}{c}
    \end{umlcall}
    \end{umlfragment}
    \end{umlcallself}
    \end{umlfragment}
    \end{umlcall}
    \umlcreatecall[class=E,x=8]{a}{e}
    \begin{umlfragment}
    \begin{umlcall}[op=opg(), name=test, type=synchron, return=6, dt=7, fill=red!10]{a}{e}
    \umlcreatecall[class=F, stereo=boundary, x=12]{e}{f}
    \end{umlcall}
    \begin{umlcall}[op=oph(), type=synchron, return=7]{a}{e}
    \end{umlcall}
    \end{umlfragment}
    \end{umlseqdiag}
    \end{tikzpicture}

    \begin{tikzpicture}
    \end{tikzpicture}
    \end{center}
    \end{document}
    EOF

    pdflatex test.tex
    cp test.pdf $out
  ''
