#! /bin/sh -e

buildInputs="$aterm $sdf"
. $stdenv/setup

configureFlags="--with-aterm=$aterm --with-sdf=$sdf"
genericBuild
