#! /bin/sh

module_basename="$1";

./grab-url.sh "http://search.cpan.org/dist/$module_basename/" "$module_basename".html;
