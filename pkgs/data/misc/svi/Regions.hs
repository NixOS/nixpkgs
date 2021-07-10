{-# LANGUAGE OverloadedStrings #-}
module Regions where

import qualified Data.Text as T

data US_State = US_State {
  name :: T.Text
, statefp :: T.Text
}

us_states =
  [ US_State {name="American Samoa"                              , statefp="60"}
  , US_State {name="Commonwealth of the Northern Mariana Islands", statefp="69"}
  , US_State {name="District of Columbia"                        , statefp="11"}
  , US_State {name="Guam"                                        , statefp="66"}
  , US_State {name="Puerto Rico"                                 , statefp="72"}
  , US_State {name="United States Virgin Islands"                , statefp="78"}
  , US_State {name="Alabama"                                     , statefp="01"}
  , US_State {name="Alaska"                                      , statefp="02"}
  , US_State {name="Arizona"                                     , statefp="04"}
  , US_State {name="Arkansas"                                    , statefp="05"}
  , US_State {name="California"                                  , statefp="06"}
  , US_State {name="Colorado"                                    , statefp="08"}
  , US_State {name="Connecticut"                                 , statefp="09"}
  , US_State {name="Delaware"                                    , statefp="10"}
  , US_State {name="Florida"                                     , statefp="12"}
  , US_State {name="Georgia"                                     , statefp="13"}
  , US_State {name="Hawaii"                                      , statefp="15"}
  , US_State {name="Idaho"                                       , statefp="16"}
  , US_State {name="Illinois"                                    , statefp="17"}
  , US_State {name="Indiana"                                     , statefp="18"}
  , US_State {name="Iowa"                                        , statefp="19"}
  , US_State {name="Kansas"                                      , statefp="20"}
  , US_State {name="Kentucky"                                    , statefp="21"}
  , US_State {name="Louisiana"                                   , statefp="22"}
  , US_State {name="Maine"                                       , statefp="23"}
  , US_State {name="Maryland"                                    , statefp="24"}
  , US_State {name="Massachusetts"                               , statefp="25"}
  , US_State {name="Michigan"                                    , statefp="26"}
  , US_State {name="Minnesota"                                   , statefp="27"}
  , US_State {name="Mississippi"                                 , statefp="28"}
  , US_State {name="Missouri"                                    , statefp="29"}
  , US_State {name="Montana"                                     , statefp="30"}
  , US_State {name="Nebraska"                                    , statefp="31"}
  , US_State {name="Nevada"                                      , statefp="32"}
  , US_State {name="New Hampshire"                               , statefp="33"}
  , US_State {name="New Jersey"                                  , statefp="34"}
  , US_State {name="New Mexico"                                  , statefp="35"}
  , US_State {name="New York"                                    , statefp="36"}
  , US_State {name="North Carolina"                              , statefp="37"}
  , US_State {name="North Dakota"                                , statefp="38"}
  , US_State {name="Ohio"                                        , statefp="39"}
  , US_State {name="Oklahoma"                                    , statefp="40"}
  , US_State {name="Oregon"                                      , statefp="41"}
  , US_State {name="Pennsylvania"                                , statefp="42"}
  , US_State {name="Rhode Island"                                , statefp="44"}
  , US_State {name="South Carolina"                              , statefp="45"}
  , US_State {name="South Dakota"                                , statefp="46"}
  , US_State {name="Tennessee"                                   , statefp="47"}
  , US_State {name="Texas"                                       , statefp="48"}
  , US_State {name="Utah"                                        , statefp="49"}
  , US_State {name="Vermont"                                     , statefp="50"}
  , US_State {name="Virginia"                                    , statefp="51"}
  , US_State {name="Washington"                                  , statefp="53"}
  , US_State {name="West Virginia"                               , statefp="54"}
  , US_State {name="Wisconsin"                                   , statefp="55"}
  , US_State {name="Wyoming"                                     , statefp="56"} ]
