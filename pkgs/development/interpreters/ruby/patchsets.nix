{ rvmPatchsets }:

{
  "2.7.6" = [
    "${rvmPatchsets}/patches/ruby/2.7/head/railsexpress/01-fix-with-openssl-dir-option.patch"
    "${rvmPatchsets}/patches/ruby/2.7/head/railsexpress/02-fix-broken-tests-caused-by-ad.patch"
    "${rvmPatchsets}/patches/ruby/2.7/head/railsexpress/03-improve-gc-stats.patch"
    "${rvmPatchsets}/patches/ruby/2.7/head/railsexpress/04-more-detailed-stacktrace.patch"
    "${rvmPatchsets}/patches/ruby/2.7/head/railsexpress/05-malloc-trim.patch"
  ];
  "3.0.4" = [
    "${rvmPatchsets}/patches/ruby/3.0/head/railsexpress/01-fix-with-openssl-dir-option.patch"
    "${rvmPatchsets}/patches/ruby/3.0/head/railsexpress/02-improve-gc-stats.patch"
    "${rvmPatchsets}/patches/ruby/3.0/head/railsexpress/03-malloc-trim.patch"
  ];
  "3.1.2" = [
    "${rvmPatchsets}/patches/ruby/3.1/head/railsexpress/01-improve-gc-stats.patch"
    "${rvmPatchsets}/patches/ruby/3.1/head/railsexpress/02-malloc-trim.patch"
  ];
}
